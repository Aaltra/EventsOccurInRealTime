using FluentMigrator;

namespace TurboPolyp.Migrations
{
    [Migration(202411031700)]
    public class CreateTablesMigration : Migration
    {
        public override void Up()
        {
            Create.Table("Seat")
                .WithColumn("Id").AsGuid().PrimaryKey()
                .WithColumn("Number").AsInt16()
                .WithColumn("TimeSlot").AsDateTime()
                .WithColumn("Taken").AsBoolean();
        }

        public override void Down()
        {
            Delete.Table("Seat");
        }

    }
}
