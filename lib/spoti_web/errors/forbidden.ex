defmodule Spoti.Errors.Forbidden do
  def html do
    Spoti.Errors.Layout.render(
      "403 — Forbidden",
      "You are not allowed to access this resource."
    )
  end

  def json do
    ~s({"error":"forbidden"})
  end
end
