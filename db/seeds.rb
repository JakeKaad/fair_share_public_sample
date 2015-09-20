#Classrooms
@classrooms = [
  ["Redwood", "Children's House"],
  ["Juniper", "Children's House"],
  ["Larch", "Children's House"],
  ["Fir", "Children's House"],
  ["Alder","Lower Elementary"],
  ["Pine", "Lower Elementary"],
  ["Spruce", "Lower Elementary"],
  ["Hawthorn", "Lower Elementary"],
  ["Walnut", "Upper Elementary"],
  ["Maple", "Upper Elementary"],
  ["Willow", "Upper Elementary"],
  ["Saint Francis Academy", "SFA"]
]

@classrooms.each do |name, level|
  Classroom.find_or_create_by(name: name, level: level)
end

#Categories
categories = [
  "Student Life",
  "School Operations",
  "Grounds and Maintenance",
  "Development",
  "Parent Community",
  "Incentives",
  "Other"
]

def create_categories(categories)
  categories.each do |name|
    new_category = Category.find_or_create_by(name: name)
    create_activities(new_category)
  end
end

#Activities and Subactivities
def create_activities(category)
  studentlife = [
    ["Room Rep", [["Room Rep", 25]]],
    ["Story Buddies (Reading)", [["Story Buddies (Reading)",0]]],
    ["Earth Experience (E2)", [["1 night",20],["2 night",30],["3 night",30]]],
    ["SFA Week-Long Trip", [["4-night +",40]]],
    ["Field Trip Chaperone",[["Field Trip Chaperone",0]]],
    ["Summer Camps",[["Summer Camps",0]]],
    ["Sports & Clubs",[["Volleyball"],["Hot Shots"],["Swimming"],["Basketball"],["Track & Field"],["Soccer"]]],
    ["Language Exchange Host",[["Language Exchange Host", 30]]],
    ["Classroom Projects & Events", @classrooms]
  ]

  schooloperations = [
    ["Library", [["Work in Library", 0],["Book Fairs", 0]]],
    ["Administrative Committees", [["Advisory Council",0],["Finance",0],["Marketing",0]]],
    ["Take-Home Work", @classrooms]
  ]

  groundsandmaintenance = [
    ["Committee", [["Committee", 0]]],
    ["Landscape/Maintenance", [["Landscape/Maintenance", 0]]],
    ["Bridal Veil", [["Bridal Veil", 0]]],
  ]

  development = [
    ["Meet the Maker", [["Meet the Maker", 0]]],
    ["Donor Recognition", [["Donor Recognition", 0]]],
    ["Auction", [["Steering Committee", 0],["Committee Chair", 0],["Procurement", 0],["Advertising/Sponsorships", 0],["Ticket Sales", 0],["Decorations",0],["Administrative", 0], ["Package Creation", 0], ["Set Up", 0],["Event Night", 0],["Balloon Bonanza", 0],["Student Volunteers", 0]]],
  ]

  parentcommunity = [
    ["Harvest Carnival", [["Harvest Carnival", 0]]],
    ["Spring Variety Show", [["Spring Variety Show", 0]]],
    ["Staff Appreciation Week", [["Staff Appreciation Week", 0]]],
    ["SCRIP Operations", [["SCRIP Operations", 0]]],
    ["Meetings & Educational Events", [["Meetings", 0],["Silent Journey", 0],["Educational", 0]]],
    ["School Store",[["School Store", 0]]]
  ]

  incentives = [
    ["Fair Share Online",[["Create Account", 1]]],
    ["New Family Referral",[["New Family Enrolled", 10]]],
    ["SCRIP Purchase",[["$250 = 1 hour", 1]]]
  ]

  other = [
    ["Other",[["Other", 0]]]
  ]

  category_activities = eval(category.name.downcase.delete(' '))
  category_activities.each do |activity|
    archived = false
    new_activity = Activity.find_or_create_by(name: activity.first, category_id: category.id, archived: false)
    subactivities = activity.last
      subactivities.each do |name, hours|
      if hours.is_a? Integer
       assigned_hours = hours
      else
       assigned_hours = 0
      end
      Subactivity.find_or_create_by(name: name, assigned_hours: assigned_hours, activity_id: new_activity.id, archived: false)
    end
  end
end

create_categories(categories)
