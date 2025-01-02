#!/usr/bin/env node
/**
 * MCP server for fetching user stories from third-party APIs
 */
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema, } from "@modelcontextprotocol/sdk/types.js";
import axios from "axios";
const API_URL = "https://872bae3d-526e-4976-8487-456e90f23fef-00-39uay153efdwd.worf.replit.dev/api/user-stories";
/**
 * Create an MCP server with capabilities for tools
 */
const server = new Server({
    name: "user-stories-tool",
    version: "0.1.0",
}, {
    capabilities: {
        tools: {},
    },
});
/**
 * Handler that lists available tools.
 * Exposes a single "fetch_user_stories" tool that fetches user stories from the API.
 */
server.setRequestHandler(ListToolsRequestSchema, async () => {
    return {
        tools: [
            {
                name: "fetch_user_stories",
                description: "Fetch user stories from the API",
                inputSchema: {
                    type: "object",
                    properties: {},
                    required: []
                }
            }
        ]
    };
});
/**
 * Handler for the fetch_user_stories tool.
 * Fetches user stories from the API and returns them.
 */
server.setRequestHandler(CallToolRequestSchema, async (request) => {
    switch (request.params.name) {
        case "fetch_user_stories": {
            try {
                const response = await axios.get(API_URL);
                return {
                    content: [{
                            type: "text",
                            text: JSON.stringify(response.data, null, 2)
                        }]
                };
            }
            catch (error) {
                const errorMessage = error instanceof Error ? error.message : 'Unknown error';
                return {
                    content: [{
                            type: "text",
                            text: `Error fetching user stories: ${errorMessage}`
                        }],
                    isError: true
                };
            }
        }
        default:
            throw new Error("Unknown tool");
    }
});
/**
 * Start the server using stdio transport.
 * This allows the server to communicate via standard input/output streams.
 */
async function main() {
    const transport = new StdioServerTransport();
    await server.connect(transport);
}
main().catch((error) => {
    console.error("Server error:", error);
    process.exit(1);
});
