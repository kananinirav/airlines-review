import React, { useState, useEffect, Fragment }from "react";
import axios from "axios"
import Header from "./Header"
import styled from "styled-components"
import ReviewForm from "./ReviewForm"
import Review from "./Review"

const Wrapper = styled.div`
  margin-left: auto;
  margin-right: auto;
`
const Column = styled.div`
  background: #fff; 
  max-width: 50%;
  width: 50%;
  float: left; 
  height: 100vh;
  overflow-x: scroll;
  overflow-y: scroll; 
  overflow: scroll;
  &::-webkit-scrollbar {
    display: none;
  }
  &:last-child {
    background: black;
    border-top: 1px solid rgba(255,255,255,0.5);
  }
`
const Main = styled.div`
  padding-left: 60px;
`

const Airline = (props) => {
  const [airline, setAirline] = useState({});
  const [review, setReview] = useState({});
  const [loaded, setLoaded] = useState(false);
  const [error, setError] = useState('')

  useEffect(()=> {
    const slug = props.match.params.slug;
    const url = `/api/v1/airlines/${slug}`

    axios.get(url)
    .then(resp => {
      setAirline(resp.data)
      setLoaded(true)
    })
    .catch(resp => console.log(resp))
  }, [])

  // Modify text in review form
  const handleChange = (e) => {
    setReview(Object.assign({}, review, {[e.target.name]: e.target.value}))
  }

  // Create a review
  const handleSubmit = (e) => {
    e.preventDefault()

    const airline_id = parseInt(airline.data.id)
    axios.post('/api/v1/reviews', { review, airline_id })
    .then( resp => {
      const included = [...airline.included, resp.data.data]
      setAirline({...airline, included})
      setReview({ title: '', description: '', score: 0 })
      setError('')
    })
    .catch( resp => {
      let error
      switch(resp.message){
        case "Request failed with status code 401":
          error = 'Please log in to leave a review.'
          break
        default:
          error = 'Something went wrong.'
      }
      setError(error)
    })
  }

  // set score
  const setRating = (score, e) => {
    e.preventDefault()  
    setReview({ ...review, score })
  }

  let total, average = 0
  let reviews
  if( loaded && airline.included) {
    reviews = airline.included.map( (review, index) => {
        return (
          <Review 
            key={index}
            id={review.id}
            attributes={review.attributes}
          />
        )
    })
  }

  return (
    <Wrapper>
       {
          loaded &&
          <Fragment>
            <Column>
              <Main>
                  
                  <Header 
                    attributes={airline.data.attributes}
                    reviews={airline.included}
                  />
                {reviews}
              </Main>
            </Column>
            <Column>
              <ReviewForm
              handleChange={handleChange}
              handleSubmit={handleSubmit}
              attributes={airline.data.attributes}
              review={review}
              setRating={setRating}
              />
            </Column>
          </Fragment>
      }
    </Wrapper>
  )
}

export default Airline