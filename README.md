Usage with compose file:
```bash
docker-compose up
```

## Environment
```bash
PORT="27016"
MAXPLAYERS="10"
MAP="crossfire"
SERVER_NAME="My HalfLife Server!"
SV_LAN="0"
RCON_PASSWORD=""
```

## ARG values
<table>
    <thead>
        <tr>
            <th>ARG Name</th>
            <th>Support values list</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>MOD</code></td>
            <td>
                - <code>valve</code><br>
                - <code>cstrike</code><br>
                - <code>czero</code><br>
                - <code>dod</code><br>
                - <code>gearbox</code><br>
                - <code>tfc</code><br>
                - <code>ricochet</code><br>
                - <code>dmc</code><br>
            </td>
            <td>Used for all mods</td>
        </tr>
        <tr>
            <td><code>REHLDS_VERSION</code></td>
            <td>
                <code>latest</code>,
                <a href="https://github.com/dreamstalker/rehlds/tags">ReHLDS tags</a>
            </td>
            <td>Used for all mods</td>
        </tr>
        <tr>
            <td><code>REGAMEDLL_VERSION</code></td>
            <td>
                <code>latest</code>,
                <a href="https://github.com/s1lentq/ReGameDLL_CS/tags">ReGameDLL_CS tags</a>
            </td>
            <td>Used for mods only:<br>- <code>cstrike</code> <br>- <code>czero</code></td>
        </tr>
        <tr>
            <td><code>BugfixedHL_LINK</code></td>
            <td>
                <a href="https://github.com/tmp64/BugfixedHL-Rebased/releases">BugfixedHL-Rebased</a> server asset link
            </td>
            <td>Used for mods only:<br>- <code>valve</code></td>
        </tr>
    </tbody>
</table>
