abort "Seeds are sample data for development only." unless Rails.env.development?

Administrator.find_or_create_by!(email: "commish@example.com") do |admin|
  admin.first_name = "Commish"
  admin.last_name = "Ioner"
  admin.password = "password"
  admin.password_confirmation = "password"
end

%w[owner1@example.com owner2@example.com owner3@example.com].each do |email|
  Owner.find_or_create_by!(email: email)
end

[
  {
    title: "Week 1 Power Rankings",
    published_at: 3.days.ago,
    sent_at: 3.days.ago,
    content: "## The contenders\n\n1. **Team Alpha** looked unstoppable.\n2. **Team Bravo** rode a monster Sunday.\n\n## The pretenders\n\nEveryone else. Better luck next week."
  },
  {
    title: "Trade Deadline Recap",
    published_at: 1.day.ago,
    content: "Three trades went through before the deadline. Here's who won each one."
  },
  {
    title: "Playoff Preview (scheduled)",
    published_at: 3.days.from_now,
    content: "This post is scheduled and shouldn't be visible yet."
  },
  {
    title: "Half-written draft",
    published_at: nil,
    content: "Draft with no publish date."
  }
].each do |attrs|
  Post.find_or_create_by!(title: attrs[:title]) { |post| post.assign_attributes(attrs) }
end
