#!/sbin/runscript
# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

checkconfig() {
	test -s "${BLOCKLISTFILE}" && return
	einfo
	einfo "Block list file ${BLOCKLISTFILE} not found, running moblock-update."
	einfo
	moblock-update
	test -s "${BLOCKLISTFILE}" && return

	eerror "moblock-update failed, cannot start"
	return 1
}

start() {
	checkconfig || return 1

	ebegin "Starting MoBlock"
	
	# Is this needed?
	#modprobe ipt_NFQUEUE

	# Filter all traffic, edit for your needs

	iptables -N MOBLOCK_IN
	iptables -N MOBLOCK_OUT
	iptables -N MOBLOCK_FW

	if [ ${ACTIVATE_CHAINS} -eq 1 ]; then
		iptables -I INPUT -p all -m state --state NEW -j MOBLOCK_IN
		iptables -I OUTPUT -p all -m state --state NEW -j MOBLOCK_OUT
		iptables -I FORWARD -p all -m state --state NEW -j MOBLOCK_FW	
	fi

	iptables -I MOBLOCK_IN -p all -j ${TARGET}
	iptables -I MOBLOCK_OUT -p all -j ${TARGET}
	iptables -I MOBLOCK_FW -p all -j ${TARGET}

	for PORT in ${WHITE_TCP_OUT}; do
		iptables -I MOBLOCK_OUT -p tcp --dport ${PORT} -j ACCEPT
	done
	for PORT in ${WHITE_UDP_OUT}; do
		iptables -I MOBLOCK_OUT -p udp --dport ${PORT} -j ACCEPT
	done

	for PORT in ${WHITE_TCP_IN}; do
		iptables -I MOBLOCK_IN -p tcp --dport ${PORT} -j ACCEPT
	done
	for PORT in ${WHITE_UDP_IN}; do
		iptables -I MOBLOCK_IN -p udp --dport ${PORT} -j ACCEPT
	done

	for PORT in ${WHITE_TCP_FORWARD}; do
		iptables -I MOBLOCK_FW -p tcp --dport ${PORT} -j ACCEPT
	done
	for PORT in ${WHITE_UDP_FORWARD}; do
		iptables -I MOBLOCK_FW -p udp --dport ${PORT} -j ACCEPT
	done
	
	# IP Blacklisting
	for IP in ${BLACK_IP_IN}; do
		iptables -I MOBLOCK_IN --source ${IP} -j DROP
	done
	for IP in ${BLACK_IP_OUT}; do
		iptables -I MOBLOCK_OUT --source ${IP} -j DROP
	done
	for IP in ${BLACK_IP_FORWARD}; do
		iptables -i MOBLOCK_FORWARD --source ${IP} -j DROP
	done
 	
	# IP whitelisting
	for IP in ${WHITE_IP_IN}; do
		iptables -I MOBLOCK_IN --source ${IP} -j RETURN
	done
	for IP in ${WHITE_IP_OUT}; do
		iptables -I MOBLOCK_OUT --destination ${IP} -j RETURN
	done
	for IP in ${WHITE_IP_FORWARD}; do
		iptables -I MOBLOCK_FW --source ${IP} -j RETURN
		iptables -I MOBLOCK_FW --destination $IP -j RETURN
	done

	# Loopback traffic fix

	iptables -I INPUT -p all -i lo -j ACCEPT
	iptables -I OUTPUT -p all -o lo -j ACCEPT

	# Here you can change block list and log files

	if start-stop-daemon --start --quiet --background --pidfile ${PIDFILE} \
			--exec /usr/sbin/moblock -- \
			${BLOCKLISTTYPE} "${BLOCKLISTFILE}" "${LOGFILE}"; then
		eend 0
	else
		# If startup failed, we need to cleanup iptables
		cleanup_iptables
		eend 1
	fi
}

cleanup_iptables() {
	if [ ${ACTIVATE_CHAINS} -eq 1 ]; then
		iptables -D INPUT -p all -m state --state NEW -j MOBLOCK_IN
		iptables -D OUTPUT -p all -m state --state NEW -j MOBLOCK_OUT
		iptables -D FORWARD -p all -m state --state NEW -j MOBLOCK_FW
	fi

	iptables -D INPUT -p all -i lo -j ACCEPT
	iptables -D OUTPUT -p all -o lo -j ACCEPT

	iptables -F MOBLOCK_IN
	iptables -X MOBLOCK_IN
	iptables -F MOBLOCK_OUT
	iptables -X MOBLOCK_OUT
	iptables -F MOBLOCK_FW
	iptables -X MOBLOCK_FW
}

stop() {
	ebegin "Stopping MoBlock"
	start-stop-daemon --stop --pidfile ${PIDFILE}
	eend ${?}
	
	# On exit delete the rules we added
	cleanup_iptables
}
