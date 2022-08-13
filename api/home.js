module.exports.handler = async () => {
	return {
		statusCode: 200,
		headers: {
			"Content-Type": "application/json",
		},
		body: JSON.stringify({
			error: false,
			message: "Home API",
		}),
	};
};
