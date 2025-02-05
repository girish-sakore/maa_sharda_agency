# Partitioning by Year/Month

Partitioning is a database optimization technique where a large table is split into smaller, more manageable pieces (partitions) based on a key (e.g., year and month). Each partition acts like a separate table, but queries can still treat them as a single table.

## Why Partition?
For your use case:

- You expect thousands of drafts per month.
- Queries are often filtered by month and year.
- Over time, the table could grow to millions of rows.

### Benefits of Partitioning:
- **Query Performance**: Smaller partitions mean faster scans.
- **Maintenance**: Easier to archive or delete old data (e.g., drop a partition for 2022).
- **Storage**: Older partitions can be moved to cheaper storage.

## How to Partition by Year/Month

### Step 1: Enable Partitioning
If you're using PostgreSQL, you can use native table partitioning. For other databases, check their documentation.

### Step 2: Modify the Table
Instead of a single `allocation_drafts` table, you'll create a partitioned table and child tables for each month/year.

#### Migration Example:
```ruby
class CreatePartitionedAllocationDrafts < ActiveRecord::Migration[6.1]
  def change
    # Create the partitioned parent table
    create_table :allocation_drafts, id: false do |t|
      t.integer :id, primary_key: true
      t.integer :month
      t.integer :year
      t.references :financial_entity
      # Add all other columns here
    end

    # Set up partitioning
    execute <<-SQL
      CREATE TABLE allocation_drafts (
        id SERIAL PRIMARY KEY,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        financial_entity_id INTEGER NOT NULL,
        -- Other columns
      ) PARTITION BY LIST (year, month);
    SQL
  end
end
```

### Step 3: Create Monthly Partitions
For each month/year, create a child table:

```ruby
execute <<-SQL
  CREATE TABLE allocation_drafts_y2024_m03 PARTITION OF allocation_drafts
  FOR VALUES IN (2024, 3);
SQL
```

### Step 4: Automate Partition Creation
Use a Rails task to create partitions for future months:

```ruby
# lib/tasks/create_partitions.rake
task create_partitions: :environment do
  (0..12).each do |i|
    date = Date.current + i.months
    year = date.year
    month = date.month

    ActiveRecord::Base.connection.execute <<-SQL
      CREATE TABLE IF NOT EXISTS allocation_drafts_y#{year}_m#{month} PARTITION OF allocation_drafts
      FOR VALUES IN (#{year}, #{month});
    SQL
  end
end
```

Run this task monthly via a cron job or scheduler (e.g., Sidekiq, Heroku Scheduler).

## When to Use Partitioning?
- **Current Table Size**: If your table is < 1M rows, partitioning may be premature.
- **Growth Rate**: If you expect > 100k rows/year, start planning for partitioning.
- **Query Patterns**: If most queries filter by month and year, partitioning is ideal.

## Indexing with Partitioning
With partitioning:

- **Global Indexes**: Indexes on the parent table apply to all partitions.
- **Local Indexes**: Each partition can have its own indexes.

For your case:

- Keep the `[:month, :year]` index on the parent table.
- Add a local index on `[:financial_entity_id, :month, :year]` for entity-specific queries.

## Example Query with Partitioning

```ruby
# Fetch drafts for entity 5 in March 2024
AllocationDraft.where(
  financial_entity_id: 5,
  month: 3,
  year: 2024
)
```

### How the Database Optimizes the Query:
1. Identifies the partition `allocation_drafts_y2024_m03`.
2. Uses the local index for `financial_entity_id`.

---

By implementing partitioning, you can improve query performance, simplify maintenance, and optimize storage as your dataset grows.

