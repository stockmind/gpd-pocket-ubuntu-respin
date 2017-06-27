fan control daemon for gpd pocket<br>

files go: <br>
gpdfand.service => /etc/systemd/system/gpdfand.service <br>
gpdfand => /lib/systemd/system-sleep/gpdfand <br>
gpdfand.pl => /usr/local/bin/gpdfand <br>

to make work:<br>
chmod +x /lib/systemd/system-sleep/gpdfand /usr/local/bin/gpdfand<br>

apt-get -y install libproc-daemon-perl libproc-pid-file-perl liblog-dispatch-perl<br>

systemctl daemon-reload<br>
systemctl enable gpdfand.service<br>
systemctl start gpdfand.service<br>

no warranty blah blah do whatever with it<br>
