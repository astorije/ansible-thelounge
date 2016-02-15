module.exports = {
	public: false,
	host: "0.0.0.0",
	port: 9000,
	bind: undefined,
	theme: "themes/{{ shout_theme }}.css",
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
		nick: "shout-user",
		username: "shout-user",
		realname: "Shout User",
		join: "#foo, #shout-irc"
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
