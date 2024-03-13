using Microsoft.AspNetCore.SignalR;
using TurboPolyp.Repositories;

namespace TurboPolyp
{
    public class SeatHub: Hub
    {
        private readonly SeatRepository _seatRepository;
        public SeatHub(SeatRepository seatRepository)
        {
            _seatRepository = seatRepository;
        }
        public async Task ReserveSeat(string seatId)
        {
            _seatRepository.ReserveSeat(Guid.Parse(seatId));

            await Clients.All.SendAsync("BlockSeat", seatId);
        }
    }
}
