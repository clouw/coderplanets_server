defmodule GroupherServerWeb.Middleware.CutParticipators do
  @moduledoc """
  # cut comments participators manually by count
  # this tem solution may have performace issue when the content's comments
  # has too much participators
  #
  # NOTE: this is NOT the right solution
  # should use WINDOW function
  # see https://github.com/coderplanets/coderplanets_server/issues/16
  #
  """

  @behaviour Absinthe.Middleware
  @default_length 5

  def call(%{errors: errors} = resolution, _) when length(errors) > 0, do: resolution

  def call(%{value: value, arguments: %{filter: %{first: first}} = args} = resolution, _) do
    %{resolution | value: value |> Enum.reverse() |> Enum.slice(0, first)}
  end

  def call(%{value: value} = resolution, _) do
    %{resolution | value: value |> Enum.reverse() |> Enum.slice(0, @default_length)}
  end

  def call(resolution, _), do: resolution
end