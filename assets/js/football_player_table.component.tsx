import React from "react";
interface FootballPlayer {
    name: string,
    team: string,
    position: string,
    longest_rush: string,
    longest_rush_touchdown: boolean,
    rushing_20plus_yards_each: number,
    rushing_40plus_yards_each: number,
    rushing_attempts: number,
    rushing_attempts_per_game_average: number,
    rushing_average_yards_per_attempt: number,
    rushing_first_down_percentage: number,
    rushing_first_downs: number
    rushing_fumbles: number,
    rushing_yards_per_game: number,
    total_rushing_touchdowns: number,
    total_rushing_yards: number
}

interface FootballPlayerTableProps {
}
interface FootballPlayerTableState {
    players: Array<FootballPlayer>;
    page: number;
    total_rushing_yards: string | null;
    longest_rush: string | null;
    total_rushing_touchdowns: string | null;
}

class FootballPlayerTable extends React.Component<FootballPlayerTableProps, FootballPlayerTableState>{
    state: FootballPlayerTableState = {
        players: [],
        page: 1,
        total_rushing_yards: null,
        longest_rush: null,
        total_rushing_touchdowns: null
    };

    componentDidMount() {
        let params: any = {
            total_rushing_yards: this.state.total_rushing_yards,
            longest_rush: this.state.longest_rush,
            total_rushing_touchdowns: this.state.total_rushing_touchdowns
        };

        Object.keys(params).forEach(key => {
            if (!params[key]) {
              delete params[key];
            }
          });

        let url_params = new URLSearchParams(params).toString();
        let url = 'api/football/players';
        if(url_params.length > 0) {
            url = url + '?' + url_params;
        }

        fetch(url).then((res) => {
            return res.json();
        }).then((players) => {
            //console.log(players);
            //players = players.slice(0, 6);
            this.setState({players});
        }); 
    }

    render() {
        return (
            <div>
                <button onClick={() => this.setState({page: Math.max(this.state.page - 1, 1) })}>Prev</button>
                <button onClick={() => this.setState({page: Math.min(this.state.page + 1, Math.floor(this.state.players.length / 6))})}>Next</button>
                <table>
                    <tr>
                        <th>Name</th>
                        <th>Team</th>
                        <th>Pos</th>
                        <th>Att/G</th>
                        <th>Attempts</th>
                        <th onClick={() => this.setState({total_rushing_yards: (this.state.total_rushing_yards == 'desc') ? 'asc' : 'desc'})}>Yards</th>
                        <th>Avg</th>
                        <th>Yds/G</th>
                        <th>TD</th>
                        <th>Lng</th>
                        <th>Touchdown?</th>
                        <th>1st</th>
                        <th>1st%</th>
                        <th>20+</th>
                        <th>40+</th>
                        <th>FUM</th>
                    </tr>
                    {
                        this.state.players.slice(6 * (this.state.page - 1), 6 * (this.state.page)).map((player) => {
                        return (<tr>
                            <td>{player.name}</td>
                            <td>{player.team}</td>
                            <td>{player.position}</td>
                            <td>{player.rushing_attempts_per_game_average}</td>
                            <td>{player.rushing_attempts}</td>
                            <td>{player.total_rushing_yards}</td>
                            <td>{player.rushing_average_yards_per_attempt}</td>
                            <td>{player.rushing_yards_per_game}</td>
                            <td>{player.total_rushing_touchdowns}</td>
                            <td>{player.longest_rush}</td>
                            <td>{player.longest_rush_touchdown ? 'Y' : 'N'}</td>
                            <td>{player.rushing_first_downs}</td>
                            <td>{player.rushing_first_down_percentage}</td>
                            <td>{player.rushing_20plus_yards_each}</td>
                            <td>{player.rushing_40plus_yards_each}</td>
                            <td>{player.rushing_fumbles}</td>
                        </tr>);
                    })}
                </table>
            </div>
        );
    }
}

export default FootballPlayerTable;
