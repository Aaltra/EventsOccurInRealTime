using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using TurboPolyp.Models;
using TurboPolyp.Repositories;

namespace TurboPolyp.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        private readonly SeatRepository _seatRepository;

        public IEnumerable<IGrouping<DateTime,Seat>> GroupedSeats { get; set; }

        public IndexModel(ILogger<IndexModel> logger, SeatRepository seatRepository)
        {
            _logger = logger;
            _seatRepository = seatRepository;
        }

        public void OnGet()
        {
            GroupedSeats = _seatRepository.GetTodaysSeats().GroupBy(seat => seat.TimeSlot).OrderBy(s => s.Key.Hour);
        }
    }
}