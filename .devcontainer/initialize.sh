#!/bin/bash

# Install project dependencies
npm install

# Create necessary directories
mkdir -p /home/codespace/.vscode-remote/data/User/globalStorage/saoudrizwan.claude-dev/settings

# Create MCP settings file
cat > /home/codespace/.vscode-remote/data/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json << 'EOF'
{
  "mcpServers": {
    "user-stories": {
      "command": "node",
      "args": ["/workspaces/dev-container/user-stories-server/build/index.js"],
      "env": {}
    }
  }
}
EOF

# Set proper permissions
chmod 644 /home/codespace/.vscode-remote/data/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json

# Build the user-stories server if it exists
if [ -d "/workspaces/dev-container/user-stories-server" ]; then
    cd /workspaces/dev-container/user-stories-server
    npm install
    npm run build
fi