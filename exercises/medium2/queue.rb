class QueueItem
  attr_reader :value, :time

  def initialize(val, time)
    @value = val
    @time = time
  end
end

class CircularQueue

  def initialize(size)
    @queue = initial_queue(size)
    @time = 0
  end

  def enqueue(val)
    dequeue unless has_empty_spots?

    increment_time
    @queue[first_empty_idx] = QueueItem.new(val, @time)
  end

  def dequeue
    return nil if empty?

    oldest = oldest_queue_item
    @queue[oldest_index] = QueueItem.new(nil, @time)
    oldest.value
  end

  private

  def initial_queue(size)
    q = []
    size.times { |_| q << QueueItem.new(nil, @@queue_time) }
    q
  end

  def oldest_queue_item
    filled_items.min_by { |q| q.time }
  end

  def oldest_index
    @queue.index(oldest_queue_item)
  end

  def empty?
    @queue.all? { |q| q.value == nil }
  end

  def increment_time
    @time += 1
  end

  def has_empty_spots?
    @queue.any? { |q| q.value == nil }
  end

  def first_empty_idx
    @queue.index(empty_items.first)
  end

  def empty_items
    @queue.select { |q| q.value == nil}
  end

  def filled_items
    @queue.select { |q| q.value != nil}
  end

  def to_s
    puts "--------------"
    @queue.each { |q| puts "Value:#{q.value}\t Time:#{q.time}"}
    puts "--------------"
  end
end

queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil