# frozen_string_literal: true

class RemoveUserDuplicates < ActiveRecord::Migration[7.0]
  def up
    say_with_time 'removing users duplicates' do
      req_dup = ActiveRecord::Base.connection.execute <<~SQL
        SELECT id, name, MAX(created_at) AS created_at FROM users GROUP BY name
      SQL

      all_dup = ActiveRecord::Base.connection.execute <<~SQL
        SELECT a.* FROM users a JOIN (SELECT name , MAX(created_at),COUNT(*) FROM users GROUP BY name HAVING count(*)>1) b ON a.name = b.name ORDER BY a.created_at desc
      SQL

      req_dup = req_dup.map { |item| item['id'] }
      all_dup = all_dup.map { |item| item['id'] }
      non_req_dup = all_dup - req_dup
      User.where(id: non_req_dup).delete_all
    end
  end

  def down; end
end
