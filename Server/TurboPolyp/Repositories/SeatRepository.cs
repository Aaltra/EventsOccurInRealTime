using SqlKata.Execution;
using TurboPolyp.Models;

namespace TurboPolyp.Repositories
{
    public class SeatRepository
    {
        private readonly QueryFactory _queryFactory;

        public SeatRepository(QueryFactory queryFactory)
        {
            _queryFactory = queryFactory;
        }

        public IEnumerable<Seat> GetTodaysSeats()
        {
            var todaysSeats = _queryFactory.Query("seat")
                .WhereBetween("timeslot", DateTime.Today, DateTime.Today.AddHours(23))
                .Get<Seat>();
            if (todaysSeats.Any())
                return todaysSeats;
            else return InsertTodaysSeats();
        }

        public void ReserveSeat(Guid id)
        {
            _queryFactory.Query("seat").Where("id", id).Update(new
            {
                Taken = true
            });

        }

        private IEnumerable<Seat> InsertTodaysSeats()
        {
            var seats = new List<Seat>();
            for (int i = 0; i < 3; i++)
            {
                for (int j = 1; j <= 15; j++)
                {
                    var seat = new Seat
                    {
                        Id = Guid.NewGuid(),
                        TimeSlot = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 20 + i, 0, 0),
                        Taken = false
                    };
                    seats.Add(seat);

                    _queryFactory.Query("seat").Insert(new
                    {
                        seat.Id,
                        Number = j,
                        seat.TimeSlot,
                        seat.Taken
                    });
                }
            }

            return seats;
        }
       

        public Seat GetById(Guid id)
        {
            return _queryFactory.Query("seat").Where("id", id).FirstOrDefault<Seat>();
        }

    }
}
