def create_or_update_tag(options)
  tag_id = options.delete(:tag_id)
  tag = Tag.where(:tag_id => tag_id).first || Tag.new(:tag_id => tag_id)
  tag.update_attributes(options)
end

def delete_tags(tag_ids)
  tag_ids.each do |tag_id|
    tag = Tag.where(:tag_id => tag_id).first
    tag.delete if tag
  end
end

delete_tags(['global', 
            'london', 
            'learning', 
            'people', 
            'people/tech-team', 
            'people/commercial-team', 
            'people/executive-team', 
            'people/board',
            'people/operations-team',
            'people/staff',
            'people/trainers',
            'people/members',
            'people/start-ups',
            'people/writers',
            'people/artists',
            'news'])
            
create_or_update_tag(
    title: "Featured item?",
    tag_type: "featured",
    tag_id: "featured",
    description: "Featured item?")

create_or_update_tag(
    title: "DaPaaS Partner",
    tag_type: "person",
    tag_id: "partner-biography",
    description: "DaPaaS Partner")
    
create_or_update_tag(
    title: "Team member",
    tag_type: "person",
    tag_id: "team",
    description: "Team member")

create_or_update_tag(
    title: "Trainer",
    tag_type: "person",
    tag_id: "trainers",
    description: "Trainer")

create_or_update_tag(
    title: "Member",
    tag_type: "person",
    tag_id: "members",
    description: "Member")

create_or_update_tag(
    title: "Start Ups",
    tag_type: "person",
    tag_id: "start-ups",
    description: "Start-up member")

create_or_update_tag(
    title: "Writer",
    tag_type: "person",
    tag_id: "writers",
    description: "Writer")

create_or_update_tag(
    title: "Artist",
    tag_type: "person",
    tag_id: "artists",
    description: "Artists")
    
create_or_update_tag(
    title: "Board",
    tag_type: "team",
    tag_id: "board",
    description: "Board")      
    
create_or_update_tag(
    title: "Executive Team",
    tag_type: "team",
    tag_id: "executive",
    description: "Executive Team")

create_or_update_tag(
    title: "Commercial Team",
    tag_type: "team",
    tag_id: "commercial",
    description: "Commercial Team")

create_or_update_tag(
    title: "Technical Team",
    tag_type: "team",
    tag_id: "technical",
    description: "Technical Team")

create_or_update_tag(
    title: "Operations Team",
    tag_type: "team",
    tag_id: "operation",
    description: "Operations Team")
    
create_or_update_tag(
    title: "Consultation Response",
    tag_type: "timed_item",
    tag_id: "consultation-response",
    description: "Consultation Response")

create_or_update_tag(
    title: "Procurement Item",
    tag_type: "timed_item",
    tag_id: "procurement",
    description: "Procurement Item")
                
create_or_update_tag(
    title: "News Item",
    tag_type: "article",
    tag_id: "news",
    description: "News Item")
    
create_or_update_tag(
    title: "Blog Post",
    tag_type: "article",
    tag_id: "blog",
    description: "Blog Post")

create_or_update_tag(
    title: "Media Release",
    tag_type: "article",
    tag_id: "media",
    description: "Media Release")

create_or_update_tag(
    title: "Start Up",
    tag_type: "organization",
    tag_id: "start-up",
    description: "Start Up")

create_or_update_tag(
    title: "Partner",
    tag_type: "organization",
    tag_id: "partner",
    description: "Partner")

create_or_update_tag(
    title: "Member",
    tag_type: "organization",
    tag_id: "member",
    description: "Member")
    
create_or_update_tag(
    title: "Lunchtime Lecture",
    tag_type: "event",
    tag_id: "lunchtime-lecture",
    description: "Lunchtime Lecture")
    
create_or_update_tag(
    title: "Meetup",
    tag_type: "event",
    tag_id: "meetup",
    description: "Meetup")

  create_or_update_tag(
    title: "Research Afternoon",
    tag_type: "event",
    tag_id: "research-afternoon",
    description: "Research Afternoon")
    
create_or_update_tag(
    title: "Open Data Challenge Series",
    tag_type: "event",
    tag_id: "open-data-challenge-series",
    description: "Open Data Challenge Series")
    
create_or_update_tag(
    title: "Roundtable",
    tag_type: "event",
    tag_id: "roundtable",
    description: "Roundtable")
    
create_or_update_tag(
    title: "Workshops",
    tag_type: "event",
    tag_id: "workshop",
    description: "Workshop")

create_or_update_tag(
    title: "Networking Event",
    tag_type: "event",
    tag_id: "networking-events",
    description: "Networking Event")
    
create_or_update_tag(
    title: "Panel Discussion",
    tag_type: "event",
    tag_id: "panel-discussions",
    description: "Panel Discussion")
    
create_or_update_tag(
    title: "DaPaaS",
    tag_type: "role",
    tag_id: "dapaas",
    description: "DaPaaS")

create_or_update_tag(
    title: "ODI",
    tag_type: "role",
    tag_id: "odi",
    description: "ODI")