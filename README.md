Testing out many-to-many relationships with groups, users, and documents. 

Group-User relationship implemented using rails has_many :through, with "memberships" as the join table, storing group_id, user_id, and the user's role within a group (owner or member). 

Group-Document relationship implemented using has_and_belongs_to_many. 
