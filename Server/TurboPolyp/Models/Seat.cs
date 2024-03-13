namespace TurboPolyp.Models
{
    public class Seat
    {
        public Guid Id { get; set; }
        public int Number { get; set; }
        public DateTime TimeSlot { get; set; }
        public bool Taken { get; set; }
    }
}
