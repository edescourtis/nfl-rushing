import React from "react";

const PAGE_SIZE_DEFAULT = 50;
interface FootballPlayer {
    id: any,
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
    order_by: string;
    before: any;
    after: any;
    limit: number;
}

class FootballPlayerTable extends React.Component<FootballPlayerTableProps, FootballPlayerTableState>{
    state: FootballPlayerTableState = {
        players: [],
        order_by: 'id',
        before: null,
        after: null,
        limit: PAGE_SIZE_DEFAULT
    };

    componentDidMount() {
        this.fetchPage('after');
    }

    fetchPage(direction: string) {
        let params: any = {
            order_by: this.state.order_by,
            after: (direction === 'after') ? this.state.after : null,
            before: (direction === 'before') ? this.state.before : null,
            limit: this.state.limit,
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
        }).then(({data: players, meta: meta}) => {
            this.setState({players});
            this.setState({after: meta.after});
            this.setState({before: meta.before});
        });
    }

    render() {
        console.log(this.state);
        return (
            <div>
                <button onClick={
                    () => {
                        if(!this.state.before) return;
                        this.fetchPage('before');
                    }}>Prev</button>
                <button onClick={
                    () => {
                        if(!this.state.after) return;
                        this.fetchPage('after');
                    }}>Next</button>
                <table>
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Team</th>
                        <th>Pos</th>
                        <th>Att/G</th>
                        <th>Attempts</th>
                        <th onClick={() => {
                            this.state.order_by = 'total_rushing_yards';
                            this.state.after = null;
                            this.state.before = null;
                            this.fetchPage('after');
                        }}>Yards</th>
                        <th>Avg</th>
                        <th>Yds/G</th>
                        <th onClick={() => {
                            this.state.order_by = 'total_rushing_touchdowns';
                            this.state.after = null;
                            this.state.before = null;
                            this.fetchPage('after');
                        }}>TD</th>
                        <th onClick={() => {
                            this.state.order_by = 'longest_rush';
                            this.state.after = null;
                            this.state.before = null;
                            this.fetchPage('after');
                        }}>Lng</th>
                        <th>Touchdown?</th>
                        <th>1st</th>
                        <th>1st%</th>
                        <th>20+</th>
                        <th>40+</th>
                        <th>FUM</th>
                    </tr>
                    </thead>
                    <tbody>
                    {
                        this.state.players.map((player) => {
                        return (<tr key={player.id}>
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
                    </tbody>
                </table>
            </div>
        );
    }
}

export default FootballPlayerTable;
