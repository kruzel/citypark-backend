using System;
using System.Collections.Generic;
using System.Web;

namespace CityParkWS
{

    public class DistancePredictionWrapper
    {
        public float distance { get; set; }
        public float prediction { get; set; }

        public DistancePredictionWrapper()
        {
        }

        public DistancePredictionWrapper(float dist, float pred)
        {
            prediction = pred;
            distance = dist;
        }

        public float calcProbability()
        {
            return  prediction;
        }
    }
}