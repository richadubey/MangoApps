class Movie
  attr_reader :title, :show_timings, :available_seats

  def initialize(title, show_timings, total_seats)
    @title = title
    @show_timings = show_timings
    @total_seats = total_seats
    @available_seats = Hash.new { |hash, key| hash[key] = (1..@total_seats).to_a }
    @booked_seats = Hash.new { |hash, key| hash[key] = [] }
  end

  def book_ticket(show_time, full_name)
    if @show_timings.include?(show_time) && available_seats[show_time].any?
      seat_number = available_seats[show_time].shift
      @booked_seats[show_time] << { seat_number: seat_number, full_name: full_name }
      return "Dear #{full_name}, your ticket for #{title} at #{show_time} has been successfully booked. Seat number: #{seat_number}"
    else
      return "Sorry, no available seats for #{title} at #{show_time}."
    end
  end

  def cancel_ticket(show_time, seat_number)
    booked_seat = @booked_seats[show_time].find { |seat| seat[:seat_number] == seat_number }
    if booked_seat
      full_name = booked_seat[:full_name]
      @available_seats[show_time] << seat_number
      @available_seats[show_time].sort!
      @booked_seats[show_time].delete_if { |seat| seat[:seat_number] == seat_number }
      return "Ticket canceled for #{title} at #{show_time}. Seat number: #{seat_number}. Booked by: #{full_name}"
    else
      return "Invalid seat number or no booking found for #{title} at #{show_time}."
    end
  end

  def total_seats
    @available_seats.values.flatten.length
  end

  def display_showtimes_and_availability
    puts "Showtimes for #{title}:"
    @show_timings.each_with_index { |show_time, index| puts "#{index + 1}. #{show_time}: #{available_seats[show_time].length} seats available" }
  end
end

class BookingSystem
  def initialize
    @movies = []
  end

  def add_movie(movie)
    @movies << movie
  end

  def display_movie_list
    puts
    puts "Available Movies:"
    @movies.each_with_index { |movie, index| puts "#{index + 1}. #{movie.title}" }
  end

  def display_showtimes_and_availability(movie_index)
    movie = @movies[movie_index]
    if movie
      movie.display_showtimes_and_availability
    else
      puts "Invalid movie index."
    end
  end

  def book_ticket(movie_index, show_index, full_name)
    movie = @movies[movie_index]
    if movie
      show_time = movie.show_timings[show_index]
      puts movie.book_ticket(show_time, full_name)
    else
      puts "Invalid movie index."
    end
  end

  def cancel_ticket(movie_index, show_index, seat_number)
    movie = @movies[movie_index]
    if movie
      show_time = movie.show_timings[show_index]
      puts movie.cancel_ticket(show_time, seat_number)
    else
      puts "Invalid movie index."
    end
  end
end

# Example usage:
booking_system = BookingSystem.new

# Add movies
movie1 = Movie.new("Shaitaan", ["10:00 AM", "1:00 PM", "4:00 PM"], 50)
movie2 = Movie.new("Article 370", ["11:00 AM", "3:00 PM", "7:00 PM"], 60)
booking_system.add_movie(movie1)
booking_system.add_movie(movie2)

loop do
  puts "Welcome to Movie Booking System"
  puts "1. View all movies"
  puts "2. Book ticket"
  puts "3. Cancel ticket"
  puts "4. Exit"
  print "Enter your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    booking_system.display_movie_list
  when 2
    booking_system.display_movie_list
    print "Enter the movie index: "
    movie_index = gets.chomp.to_i - 1
    booking_system.display_showtimes_and_availability(movie_index)
    print "Enter the show index: "
    show_index = gets.chomp.to_i - 1
    print "Enter your full name: "
    full_name = gets.chomp
    puts booking_system.book_ticket(movie_index, show_index, full_name)
  when 3
    booking_system.display_movie_list
    print "Enter the movie index: "
    movie_index = gets.chomp.to_i - 1
    booking_system.display_showtimes_and_availability(movie_index)
    print "Enter the show index: "
    show_index = gets.chomp.to_i - 1
    print "Enter your seat number: "
    seat_number = gets.chomp.to_i
    booking_system.cancel_ticket(movie_index, show_index, seat_number)
  when 4
    puts "Exiting..."
    break
  else
    puts "Invalid choice. Please try again."
  end

  puts "\n\n"
end
