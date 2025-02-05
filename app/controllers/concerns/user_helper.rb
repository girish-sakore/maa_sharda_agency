module UserHelper
  def serialize_users(data)
    users = []
    data.each do |user|
      users << serialize_user(user)
    end
    users
  end

  def serialize_user(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role_name
    }
  end
end