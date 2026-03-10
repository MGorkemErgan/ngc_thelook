view: derived {
  derived_table: {
    sql:
      SELECT
          (DATE(order_items.created_at )) AS order_items_created_date,
          COUNT(DISTINCT CASE WHEN ( order_facts.order_sequence_number = 1 ) THEN order_items.order_id  ELSE NULL END) AS order_items_first_purchase_count,
          COUNT(DISTINCT order_items.order_id ) AS order_items_order_count
      FROM looker-private-demo.ecomm.order_items  AS order_items
      LEFT JOIN `looker-partners.looker_scratch.LR_V4JDG1732447823517_order_facts` AS order_facts ON order_facts.order_id = order_items.order_id
      WHERE ((( order_items.created_at  ) >= ((TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY, 'UTC'), INTERVAL -6 DAY))) AND ( order_items.created_at  ) < ((TIMESTAMP_ADD(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY, 'UTC'), INTERVAL -6 DAY), INTERVAL 7 DAY)))))
      GROUP BY
          1
      ORDER BY
          1 DESC,
          3 DESC
      LIMIT 500 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_items_created_date {
    label: "Tarih"
    type: date
    datatype: date
    sql: ${TABLE}.order_items_created_date ;;
  }

  dimension: order_items_first_purchase_count {
    type: number
    sql: ${TABLE}.order_items_first_purchase_count ;;
  }

  dimension: order_items_order_count {
    type: number
    sql: ${TABLE}.order_items_order_count ;;
  }

  set: detail {
    fields: [
      order_items_created_date,
      order_items_first_purchase_count,
      order_items_order_count
    ]
  }
}
