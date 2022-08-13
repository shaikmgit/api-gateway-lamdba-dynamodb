module.exports.handler = async () => {
	return {
		statusCode: 200,
		headers: {
			"Content-Type": "text/html",
		},
		body: "The file requested was not found",
	};
};
