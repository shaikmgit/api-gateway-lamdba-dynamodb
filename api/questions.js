const AWS = require("aws-sdk");
const docClient = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (event) => {
	try {
		const jwtSecret = process.env.jwtSecret;

		const params = {
			TableName: "questions",
		};

		const { Items: questions } = await docClient.scan(params).promise();

		return {
			statusCode: 200,
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				error: false,
				jwtSecret,
				questions,
			}),
		};
	} catch (err) {
		return {
			statusCode: 200,
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				error: true,
				message: err,
			}),
		};
	}
};
