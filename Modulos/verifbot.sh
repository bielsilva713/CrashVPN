#!/bin/bash
[[ ! -d /etc/SSHPlus ]] && exit 0
[[ ! -d /etc/bot/revenda ]] && exit 0
[[ "$(ls /etc/bot/revenda| wc -l)" == '0' ]] && exit 0
for arq in $(ls /etc/bot/revenda); do
	_diasR=$(grep -w 'DIAS_REVENDA' /etc/bot/revenda/$arq/$arq | awk '{print $NF}')
	[[ "$_diasR" -eq '0' ]] && {
		[[ "$(grep -wc 'SUBREVENDA' /etc/bot/revenda/$arq/$arq)" != '0' ]] && {
			while read _listsub3; do
				_usub3="$(echo $_listsub3 | awk '{print $2}')"
				_dir_users="/etc/bot/revenda/$_usub3/usuarios"
				[[ "$(ls $_dir_users | wc -l)" != '0' ]] && {
					for _user in $(ls $_dir_users); do
						usermod -L $_user
						pkill -U $_user
					done
				}
				[[ $(grep -wc $_usub3 /etc/bot/lista_suspensos) == '0' ]] && {
					[[ ! -z $_usub3 ]] && {
						echo $_usub3 suspenso
						mv /etc/bot/revenda/$_usub3 /etc/bot/suspensos/$_usub3
						grep -w "$_usub3" /etc/bot/lista_ativos >>/etc/bot/lista_suspensos
					}
				}
			done <<<"$(grep -w 'SUBREVENDA' /etc/bot/revenda/$arq/$arq)"
		}
		[[ "$(ls /etc/bot/revenda/$arq/usuarios | wc -l)" != '0' ]] && {
			for _user in $(ls /etc/bot/revenda/$arq/usuarios); do
				usermod -L $_user
				pkill -U $_user
			done
		}
		[[ $(grep -wc $arq /etc/bot/lista_suspensos) == '0' ]] && {
			[[ ! -z $arq ]] && {
				echo $arq suspenso
				mv /etc/bot/revenda/$arq /etc/bot/suspensos/$arq
				grep -w "$arq" /etc/bot/lista_ativos >>/etc/bot/lista_suspensos
			}
		}
		echo "$arq ~ $_diasR"
	} || {
		_days=$(($_diasR - 1))
		sed -i "/\b$arq\b/ s/DIAS: $_diasR/DIAS: $_days/" /etc/bot/lista_ativos
		sed -i "/DIAS_REVENDA/ s/$_diasR/$_days/" /etc/bot/revenda/$arq/$arq
		echo $arq $_diasR DIAS ALTERADO PARA $_days
	}
done
