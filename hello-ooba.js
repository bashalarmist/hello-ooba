const axios = require('axios');
const express = require('express');
const bodyParser = require('body-parser');

// Get API and PORT details from environment variables
OOBA_API_IP = process.env.OOBA_API_IP;
HOST_OPENAI_API_PORT = process.env.HOST_OPENAI_API_PORT;

const listenPort = process.env.CONTAINER_HELLOWORLD_PORT;

// Oogabooga OpenAI API endpoint
const oobaAPIEndpoint = `http://${OOBA_API_IP}:${HOST_OPENAI_API_PORT}/api/v1/generate/chat/completions`;

// Initialize Express application
const app = express();

// Use body-parser to parse incoming JSON
app.use(bodyParser.json());

// Route to process POST requests on '/prompt'
app.post('/prompt', async (req, res) => {
    const message = req.body.message;

    if (!message) {
        return res.status(400).send('Please provide a prompt in quotes.');
    }

    console.log(`Sending request to Oogabooga API Using user string: '${message}'`);

    try {
        const requestBody = {
            messages: [
                { "role": "system", "content": "Give instructions to the system for the prompt" },
                { "role": "user", "content": "Hello bot" },
                { "role": "assistant", "content": "Hello, I am ooba bot." },
                { "role": "user", "content": message },
            ]
        };

        // Send a POST request to the Oobabooga OpenAI API
        const response = await axios.post(oobaAPIEndpoint, requestBody);

        console.log(response.data);

        const messageResult = response.data.data[0].message.content;

        // If the API response is successful and we get a message, return it
        if (response.status === 200 && messageResult) {
            return res.send(messageResult);
        } else {
            throw new Error('Failed to generate response');
        }
    } catch (error) {
        console.error('Oogabooga OpenAI API error:', error.message);
        return res.status(500).send('Failed to generate a response.');
    }
});

// Start the server
app.listen(listenPort, () => {
    console.log(`Listening on port ${listenPort}`);
});
