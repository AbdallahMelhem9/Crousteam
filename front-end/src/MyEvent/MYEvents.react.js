import React, { useContext, useState, useCallback, useEffect } from 'react';
import { View, Text, FlatList, StyleSheet, TouchableOpacity, TextInput, ActivityIndicator } from 'react-native';
import MyEventIcon from './MyEventIcon.react';
import AppContext from '../common/appcontext';
import axios from 'axios';
import { baseUrl } from '../common/const';

const styles = StyleSheet.create({

});



export default function AllEvents({ eid, setGid, log, setLog }) {

    const { page, setPage, authToken } = useContext(AppContext)

    const [events, setEvents] = useState(null);
    const [isLoading, setIsLoading] = useState(false);
    const [refreshing, setRefreshing] = useState(false);
    const [hasPermissionError, setPermissionError] = useState(false);

    const getAllEvents = useCallback(() => {
        setIsLoading(true);
        // Set refreshing to true when we are loading data on pull to refresh
        axios({
            baseURL: baseUrl,
            url: '/event-info-creator',
            method: 'GET',
            headers: { Authorization: 'Bearer ' + authToken },
        }).then(response => {
            setIsLoading(false);
            setRefreshing(false); // Set refreshing to false when data is loaded
            if (response.status == 200) {
                const parsedData = response.data.map(event => ({
                    title: event[1], loc: event[2], date: event[3], time: event[4], duration: event[5], description: event[6], gid: event[7], preferences: event[8]
                }));
                console.log(parsedData);
                setEvents(parsedData);
                setPermissionError(false);
            } else if (response.status == 403) {
                setPermissionError(true);
            }
        }).catch(err => {
            console.error(`Something went wrong ${err.message}`);
            setIsLoading(false);
            setRefreshing(false);
        });
    }, [authToken]);

    useEffect(() => {
        getAllEvents();
    }, [authToken, getAllEvents]);


    const renderEventItem = ({ item }) => { return (<MyEventIcon item={item} setGid={setGid}></MyEventIcon>) }

    return (
        <View>
            {isLoading && <ActivityIndicator size='large' animating={true} color='#FF0000' />}
            <FlatList
                data={events}
                keyExtractor={item => item.gid}
                renderItem={renderEventItem}
                numColumns={2}
            />
        </View>
    )
};
