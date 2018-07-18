defmodule MastaniServer.Test.Mutation.StatisticsTest do
  use MastaniServer.TestTools

  alias MastaniServer.Statistics
  # alias MastaniServer.Accounts.User
  alias Helper.ORM

  setup do
    guest_conn = simu_conn(:guest)
    {:ok, user} = db_insert(:user)

    {:ok, ~m(guest_conn user)a}
  end

  describe "[statistics mutaion user_contribute] " do
    @query """
    mutation($userId: ID!) {
      makeContrubute(userId: $userId) {
        date
        count
      }
    }
    """
    test "for guest user makeContribute should add record to user_contribute table",
         ~m(guest_conn user)a do
      variables = %{userId: user.id}
      assert {:error, _} = ORM.find_by(Statistics.UserContribute, user_id: user.id)
      results = guest_conn |> mutation_result(@query, variables, "makeContrubute")
      assert {:ok, _} = ORM.find_by(Statistics.UserContribute, user_id: user.id)

      assert ["count", "date"] == results |> Map.keys()
      assert results["date"] == Timex.today() |> Date.to_iso8601()
      assert results["count"] == 1
    end

    test "makeContribute to same user should update contribute count", ~m(guest_conn user)a do
      variables = %{userId: user.id}
      guest_conn |> mutation_result(@query, variables, "makeContrubute")
      results = guest_conn |> mutation_result(@query, variables, "makeContrubute")
      assert ["count", "date"] == results |> Map.keys()
      assert results["date"] == Timex.today() |> Date.to_iso8601()
      assert results["count"] == 2
    end
  end
end