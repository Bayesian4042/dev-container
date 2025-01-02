#!/bin/bash

# Install project dependencies
npm install

# Create necessary directories
mkdir -p /home/codespace/.vscode-remote/data/User/globalStorage/saoudrizwan.claude-dev/settings
mkdir -p /home/codespace/Documents/Cline/MCP/user-stories-server

# Copy project files if they exist
if [ -d "/workspaces/$(basename $PWD)/user-stories-server" ]; then
    cp -r /workspaces/$(basename $PWD)/user-stories-server/* /home/codespace/Documents/Cline/MCP/user-stories-server/
fi

# Create MCP settings file
cat > /home/codespace/.vscode-remote/data/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json << 'EOF'
{
  "mcpServers": {
    "user-stories": {
      "command": "node",
      "args": ["/home/codespace/Documents/Cline/MCP/user-stories-server/build/index.js"],
      "env": {}
    }
  }
}
EOF

# Set proper permissions
chmod 644 /home/codespace/.vscode-remote/data/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json

# Build the user-stories server if it exists
if [ -d "/home/codespace/Documents/Cline/MCP/user-stories-server" ]; then
    cd /home/codespace/Documents/Cline/MCP/user-stories-server
    npm install
    npm run build
fi