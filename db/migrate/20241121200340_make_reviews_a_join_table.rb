class MakeReviewsAJoinTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :reviews, :name, :string
    add_column :reviews, :user_id, :integeer
    Review.delete_all
  end
end
