defmodule SpotiWeb.Errors.Layout do
  def render(title, message) do
    """
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>#{title} · Spoti</title>
        <style>
          body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont;
            background: #f6f7f9;
            color: #111;
            margin: 0;
            padding: 0;
          }
          main {
            max-width: 720px;
            margin: 10vh auto;
            background: #ffffff;
            padding: 3rem;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            text-align: center;
          }
          h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
          }
          p {
            font-size: 1.1rem;
            color: #444;
          }
          footer {
            margin-top: 2rem;
            font-size: 0.9rem;
            color: #777;
          }
        </style>
      </head>
      <body>
        <main>
          <h1>#{title}</h1>
          <p>#{message}</p>
          <footer>Spoti · Sports intelligence</footer>
        </main>
      </body>
    </html>
    """
  end
end
