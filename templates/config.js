module.exports = {
	public: false,
	host: "0.0.0.0",
	port: {{ lounge_port }},
	bind: undefined,
	theme: "themes/{{ lounge_theme }}.css",
	autoload: true,
	prefetch: false,
	displayNetwork: true,
	logs: {
		format: "YYYY-MM-DD HH:mm:ss",
		timezone: "UTC+00:00"
	},
	defaults: {
		name: "Freenode",
		host: "chat.freenode.net",
		port: 6697,
		password: "",
		tls: true,
		nick: "lounge-user",
		username: "lounge-user",
		realname: "The Lounge User",
		join: "#thelounge"
	},
	transports: ["polling", "websocket"],
	https: {
		enable: false,
		key: "",
		certificate: ""
	},
	identd: {
		enable: false,
		port: 113
	}
};
