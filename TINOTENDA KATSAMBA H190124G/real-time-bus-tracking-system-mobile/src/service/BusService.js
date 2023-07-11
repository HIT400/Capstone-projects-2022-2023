import axios from 'axios';

const BUS_API_BASE_URL = 'http://127.0.0.1:8080/busses/';

class BusService {
  saveBus(bus) {
    console.log('hereeeeeeeeee');
    return axios.post(BUS_API_BASE_URL + 'save', bus);
  }

}

export default new BusService();
