ActiveAdmin.register Product do
  form do |f|
      f.inputs "Details" do
        f.input :name
        f.input :description
      end
      f.inputs "Content" do
        f.input :image
      end
      f.buttons
    end
end
