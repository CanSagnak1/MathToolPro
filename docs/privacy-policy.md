<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ToolMath — Privacy Policy</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0a0f;
            --card-bg: rgba(255,255,255,0.04);
            --border: rgba(255,255,255,0.08);
            --text: #e8e8ed;
            --text-muted: #8e8e93;
            --accent: #00E5A0;
            --accent-glow: rgba(0,229,160,0.15);
        }

        * { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.7;
            min-height: 100vh;
        }

        .hero {
            text-align: center;
            padding: 80px 20px 40px;
            background: linear-gradient(180deg, rgba(0,229,160,0.08) 0%, transparent 100%);
        }

        .hero .icon {
            width: 80px;
            height: 80px;
            border-radius: 20px;
            background: linear-gradient(135deg, var(--accent), #00b380);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            font-size: 36px;
            box-shadow: 0 8px 32px var(--accent-glow);
        }

        .hero h1 {
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
        }

        .hero .subtitle {
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        .container {
            max-width: 720px;
            margin: 0 auto;
            padding: 0 24px 80px;
        }

        .card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 32px;
            margin-top: 24px;
            backdrop-filter: blur(20px);
        }

        .card h2 {
            font-size: 1.15rem;
            font-weight: 600;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card h2 .emoji { font-size: 1.3rem; }

        .card p, .card li {
            color: var(--text-muted);
            font-size: 0.93rem;
            margin-bottom: 10px;
        }

        .card ul {
            list-style: none;
            padding: 0;
        }

        .card ul li::before {
            content: "✓";
            color: var(--accent);
            font-weight: 700;
            margin-right: 10px;
        }

        .highlight {
            background: var(--accent-glow);
            border-color: rgba(0,229,160,0.2);
        }

        .highlight p {
            color: var(--text);
            font-size: 1rem;
            font-weight: 500;
            text-align: center;
        }

        .badge {
            display: inline-block;
            background: var(--accent);
            color: #000;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 3px 10px;
            border-radius: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .date {
            text-align: center;
            color: var(--text-muted);
            font-size: 0.82rem;
            margin-top: 40px;
            padding-top: 24px;
            border-top: 1px solid var(--border);
        }

        .footer {
            text-align: center;
            padding: 32px 20px;
            color: var(--text-muted);
            font-size: 0.8rem;
        }

        .footer a {
            color: var(--accent);
            text-decoration: none;
        }

        @media (max-width: 600px) {
            .hero { padding: 60px 20px 30px; }
            .hero h1 { font-size: 1.6rem; }
            .card { padding: 24px; }
        }
    </style>
</head>
<body>

<div class="hero">
    <div class="icon">📐</div>
    <h1>ToolMath</h1>
    <p class="subtitle">Privacy Policy</p>
</div>

<div class="container">

    <div class="card highlight">
        <p>🛡️ ToolMath does <strong>not collect, store, or share</strong> any personal data.</p>
    </div>

    <div class="card">
        <h2><span class="emoji">📋</span> Overview</h2>
        <p>ToolMath is a calculator, unit converter, and graph plotter application designed for iOS. Your privacy is important to us. This policy explains what data the app accesses and how it is used.</p>
    </div>

    <div class="card">
        <h2><span class="emoji">💾</span> Data Storage</h2>
        <p>ToolMath stores the following data <strong>locally on your device only</strong>:</p>
        <ul>
            <li>App preferences and settings (theme, decimal places, angle mode, etc.)</li>
            <li>Calculation history (recent calculations)</li>
            <li>Conversion history (recent conversions)</li>
        </ul>
        <p>All data is stored using Apple's <code>UserDefaults</code> API. This data never leaves your device and is not transmitted to any server.</p>
    </div>

    <div class="card">
        <h2><span class="emoji">🚫</span> What We Do NOT Collect</h2>
        <ul>
            <li>No personal information (name, email, phone)</li>
            <li>No location data</li>
            <li>No usage analytics or tracking</li>
            <li>No advertising identifiers</li>
            <li>No third-party SDKs or analytics tools</li>
            <li>No network requests — the app works 100% offline</li>
        </ul>
    </div>

    <div class="card">
        <h2><span class="emoji">🌐</span> Network Access</h2>
        <p>ToolMath does <strong>not</strong> require an internet connection and does not make any network requests. All calculations, conversions, and graph plotting happen entirely on your device.</p>
    </div>

    <div class="card">
        <h2><span class="emoji">👶</span> Children's Privacy</h2>
        <p>ToolMath does not collect any data from anyone, including children under the age of 13. The app is safe for users of all ages.</p>
    </div>

    <div class="card">
        <h2><span class="emoji">🔄</span> Changes to This Policy</h2>
        <p>If we ever update this privacy policy, changes will be reflected on this page. Since ToolMath does not collect data, we do not anticipate significant changes.</p>
    </div>

    <div class="card">
        <h2><span class="emoji">📬</span> Contact</h2>
        <p>If you have any questions about this privacy policy, you can reach us at:</p>
        <p><strong>Email:</strong> <a href="mailto:cansagnak@icloud.com" style="color: var(--accent); text-decoration: none;">cansagnak@icloud.com</a></p>
    </div>

    <div class="date">
        <span class="badge">Effective</span><br>
        Last updated: February 15, 2026
    </div>
</div>

<div class="footer">
    <p>© 2026 ToolMath. All rights reserved.</p>
    <p><a href="https://github.com/CanSagnak1/MathToolPro">GitHub</a></p>
</div>

</body>
</html>
