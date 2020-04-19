namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    #puts("Query 0: Sample query; show the names of the events available")
    #result = Event.select(:name).distinct.map { |x| x.name }
    #puts(result)
    #puts("EOQ") # End Of Query -- always add this line after a query.

    #Query 1
    puts("Query 1: Total number of tickets bought by a given customer with id:1")
    query_1 = Customer.find(1).tickets.count 
    puts(query_1)
    puts("EOQ")

    #Query 2
    puts("Query 2: Number of different events that the customer with id:1 has attended")
    query_2= Event.joins(ticket_types: { tickets: :order} ).where(orders: {customer_id:1}).distinct.count
    puts(query_2)
    puts("EOQ")

    #Query 3
    puts("Query 3: Names of the events that the customer with id:1 has attended")
    query_3= Event.joins(ticket_types: { tickets: :order} ).where(orders: {customer_id:1}).distinct.pluck(:name)
    puts(query_3)
    puts("EOQ")

    #Query 4
    puts("Query 4: Number of tickets sold for the event with id:1")
    query_4= Ticket.joins(ticket_type: :event).where(events: {id:1}).count
    puts(query_4)
    puts("EOQ")

    #Query 5
    puts("Query 5: Total sales of the event with id:1")
    query_5= TicketType.joins(:tickets, :event).where(events: {id:1}).sum(:ticket_price)
    puts(query_5)
    puts("EOQ")

    #Query 6
    puts("Query 6: The event that has been most attended by women")
    query_6= Event.joins(ticket_types: { tickets: { order: :customer}}).where(customers: { gender: 'f' }).group(:name).order(name_count: :desc).limit(1).count
    puts(query_6)
    puts("EOQ")

    #Query 7
    puts("Query 7: The event that has been most attended by men ages 18 to 30")
    query_7= Event.joins(ticket_types: { tickets: { order: :customer}}).where("customers.gender = 'm' and 18 <= customers.age <= 30").group(:name).order(name_count: :desc).limit(1).count
    puts(query_7)
    puts("EOQ")

  end
end