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
      type: user.role_name,
      mobile_number: user.mobile_number,
      alt_mobile_number: user.alt_mobile_number,
      verified: user.verified,
      status: user.status,
    }
  end
end