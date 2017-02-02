class AddDocEmbedUrlToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :doc_embed_url, :string
  end
end
