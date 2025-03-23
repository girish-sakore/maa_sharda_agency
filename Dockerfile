# Official Ruby runtime as a parent image
FROM ruby:3.3

# Set the working directory in the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock to the working directory
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose the port your Rails app runs on
EXPOSE 3001

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]