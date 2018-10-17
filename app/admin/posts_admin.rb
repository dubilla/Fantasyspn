Trestle.resource(:posts) do
  menu do
    item :posts, icon: "fa fa-file-text-o"
  end

  # Customize the table columns shown on the index view.
  table do
    column :title, link: true
    column :updated_at, header: "Last Updated", align: :center
    actions
  end

  # Customize the form fields shown on the new/edit views.
  form do |post|
    tab :post do
      text_field :title
      editor :content
    end
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:post).permit(:name, ...)
  # end
end
