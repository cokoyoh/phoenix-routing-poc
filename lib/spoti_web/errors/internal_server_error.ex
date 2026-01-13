defmodule SpotiWeb.Errors.InternalServerError do
  def html do
    SpotiWeb.Errors.Layout.render(
      "500 — Something went wrong",
      "An unexpected error occurred. Please try again later."
    )
  end

  def json do
    ~s({"error":"internal_server_error"})
  end
end
