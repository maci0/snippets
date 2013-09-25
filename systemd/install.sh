cp *.service /etc/systemd/system

for FILE in *.service; 
do
  cp ${FILE} /etc/systemd/system
  systemctl daemon-reload
  systemctl restart ${FILE}
  systemctl enable ${FILE}
done


