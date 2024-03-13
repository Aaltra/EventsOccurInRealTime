
using Microsoft.AspNetCore.Mvc;
using TurboPolyp.Models;
using TurboPolyp.Repositories;

namespace TurboPolyp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SeatController : ControllerBase
    {
        private readonly SeatRepository _seatRepository;
        public SeatController(SeatRepository repo)
        {
            _seatRepository = repo;

        }

        [HttpGet]
        public IEnumerable<Seat> Get()
        {
            return _seatRepository.GetTodaysSeats();
        }

        [HttpPost]
        public bool ReserveSeat(string id)
        {
            _seatRepository.ReserveSeat(Guid.Parse(id));
            return true;
        }
    }
}
