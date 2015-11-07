# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

module Seed
  Person      = Struct.new(:name, :id, :books, :lists)
  Book        = Struct.new(:name, :id)
  ReadingList = Struct.new(:name, :id, :person_id)

  class Person
    def to_json
      {name: name, id: id}.to_json
    end
  end

  def self.project
    @project ||= Project.create!(name: Faker::Company.name)
  end

  def self.create_world
    @people = 5.times.map do |i|
      Person.new(
        Faker::Name.name, i,
        5.times.map {|j| Book.new(Faker::Book.title, j) },
        5.times.map {|j| ReadingList.new(Faker::Book.genre, j, i) }
      )
    end
    @books_added = Array.new
    @all_books = @people.map(&:books).flatten
  end

  def self.someone_adds_a_book_to_a_list
    book = nil
    while book.nil? && @books_added.size != @all_books.size
      actor = @people.sample
      book = (actor.books - @books_added).sample
    end
    return if book.nil?

    list = actor.lists.sample

    Event.create!(
      actor: actor.to_json,
      verb: :add,
      object: book.to_json,
      target: list.to_json,
      project: project
    )

    @books_added << book
  end

  def self.someone_likes_a_book_in_someones_list
    actor  = @people.sample
    book   = actor.books.find {|b| @books_added.include?(b)}
    target = (@people - [actor]).sample

    Event.create!(
      actor: actor.to_json,
      verb: :like,
      object: book.to_json,
      target: target.to_json,
      project: project
    )
  end
end

Seed.create_world

5.times do
  Seed.someone_adds_a_book_to_a_list
end

20.times do
  if rand(2) == 0
    Seed.someone_adds_a_book_to_a_list
  else
    Seed.someone_likes_a_book_in_someones_list
  end
end

puts "Added 25 events to the database"
