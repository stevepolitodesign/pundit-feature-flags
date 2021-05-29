class Feature::EnablePostMetaDescriptionPolicy < ApplicationPolicy
  def ceate?
    user.present? && (user.enable_post_meta_description == true)
  end

  def permitted_attributes
    if user.enable_post_meta_description == true
      [:title, :user_id, :meta_description]
    else
      [:title, :user_id]
    end
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
