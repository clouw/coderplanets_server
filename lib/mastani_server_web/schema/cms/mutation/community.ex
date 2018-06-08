defmodule MastaniServerWeb.Schema.CMS.Mutation.Community do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: MastaniServer.Repo

  alias MastaniServerWeb.{Resolvers}
  alias MastaniServerWeb.Middleware, as: M

  object :cms_mutation_community do
    @desc "create a global community"
    field :create_community, :community do
      arg(:title, non_null(:string))
      arg(:desc, non_null(:string))
      arg(:raw, non_null(:string))
      arg(:logo, non_null(:string))
      # arg(:category, non_null(:string))

      middleware(M.Authorize, :login)
      middleware(M.Passport, claim: "cms->community.create")

      resolve(&Resolvers.CMS.create_community/3)
      # middleware(M.Statistics.MakeContribute, for: :user)
      middleware(M.Statistics.MakeContribute, for: [:user, :community])
    end

    @desc "update a community"
    field :update_community, :community do
      arg(:id, non_null(:id))
      arg(:title, :string)
      arg(:desc, :string)
      arg(:raw, :string)
      arg(:logo, :string)

      middleware(M.Authorize, :login)
      middleware(M.Passport, claim: "cms->community.update")

      resolve(&Resolvers.CMS.update_community/3)
      middleware(M.Statistics.MakeContribute, for: [:user, :community])
    end

    @desc "delete a global community"
    field :delete_community, :community do
      arg(:id, non_null(:id))
      middleware(M.Authorize, :login)
      middleware(M.Passport, claim: "cms->community.delete")

      resolve(&Resolvers.CMS.delete_community/3)
    end

    @desc "create category"
    field :create_category, :category do
      arg(:title, non_null(:string))

      middleware(M.Authorize, :login)
      middleware(M.Passport, claim: "cms->category.create")

      resolve(&Resolvers.CMS.create_category/3)
    end

    @desc "update category"
    field :update_category, :category do
      arg(:id, non_null(:id))
      arg(:title, non_null(:string))

      middleware(M.Authorize, :login)
      middleware(M.Passport, claim: "cms->category.update")

      resolve(&Resolvers.CMS.update_category/3)
    end

    @desc "create independent thread"
    field :create_thread, :thread do
      arg(:title, non_null(:string))
      arg(:raw, non_null(:string))

      middleware(M.Authorize, :login)
      middleware(M.Passport, claim: "cms->thread.create")

      resolve(&Resolvers.CMS.create_thread/3)
    end

    @desc "add a editor for a community"
    field :add_cms_editor, :user do
      arg(:community_id, non_null(:id))
      arg(:user_id, non_null(:id))
      arg(:title, non_null(:string))

      middleware(M.Authorize, :login)
      middleware(M.PassportLoader, source: :community)
      middleware(M.Passport, claim: "cms->editor.add")

      resolve(&Resolvers.CMS.add_editor/3)
    end

    @desc "delete a editor from a community, the user's passport also deleted"
    field :delete_cms_editor, :user do
      arg(:community_id, non_null(:id))
      arg(:user_id, non_null(:id))

      middleware(M.Authorize, :login)
      middleware(M.PassportLoader, source: :community)
      middleware(M.Passport, claim: "cms->editor.delete")

      resolve(&Resolvers.CMS.delete_editor/3)
    end

    # TODO: remove, should remove both editor and cms->passport
    @desc "update cms editor's title, passport is not effected"
    field :update_cms_editor, :user do
      arg(:community_id, non_null(:id))
      arg(:user_id, non_null(:id))
      arg(:title, non_null(:string))

      middleware(M.Authorize, :login)
      middleware(M.PassportLoader, source: :community)
      middleware(M.Passport, claim: "cms->editor.update")

      resolve(&Resolvers.CMS.update_editor/3)
    end

    @desc "create a tag"
    field :create_tag, :tag do
      arg(:title, non_null(:string))
      arg(:color, non_null(:rainbow_color_enum))
      arg(:community_id, non_null(:id))
      arg(:part, :cms_part, default_value: :post)

      middleware(M.Authorize, :login)
      middleware(M.PassportLoader, source: :community)
      middleware(M.Passport, claim: "cms->c?->p?.tag.create")

      resolve(&Resolvers.CMS.create_tag/3)
    end

    @desc "delete a tag by part [:login required]"
    field :delete_tag, :tag do
      arg(:id, non_null(:id))
      arg(:community_id, non_null(:id))
      arg(:part, :cms_part, default_value: :post)

      middleware(M.Authorize, :login)
      middleware(M.PassportLoader, source: :community)
      middleware(M.Passport, claim: "cms->c?->p?.tag.delete")

      resolve(&Resolvers.CMS.delete_tag/3)
    end
  end
end