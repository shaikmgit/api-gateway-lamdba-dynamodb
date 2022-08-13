module.exports.handler = async (event) => {
	let responseMessage = "Hello, World!";

	if (event.queryStringParameters && event.queryStringParameters["Name"]) {
		responseMessage = "Hello, " + event.queryStringParameters["Name"];
	}

	return {
		statusCode: 200,
		headers: {
			"Content-Type": "text/html",
		},
		body: responseMessage,
	};
};
