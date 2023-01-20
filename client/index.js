exports.handler = async (event) => {
	try {
		return {
			statusCode: 200,
			headers: {
				"Content-Type": "text/html",
			},
			body: fs.readFileSync(__dirname + "/index.html", "UTF-8"),
		};
	} catch (err) {
		console.log(err);
		return {
			statusCode: 200,
			headers: {
				"Content-Type": "text/html",
			},
			body: "Error reading file",
		};
	}
};
